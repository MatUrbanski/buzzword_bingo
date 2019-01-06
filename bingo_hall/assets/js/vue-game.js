import Vue from 'vue'
import { Socket, Presence } from "phoenix"

const gameContainer = document.querySelector("#game-container")

if (gameContainer) {

  new Vue({
    el: '#game-container',
    data: {
      squares: [],
      scores: {},
      winner: null,
      messages: [],
      players: [],
      chatMessage: "",
      error: ""
    },
    methods: {
      squareStyle(square) {
        const player = square.marked_by
        return player ? { backgroundColor: player.color } : { }
      },
      sendMark(square) {
        if (!square.marked_by) {
          this.channel.push("mark_square", { phrase: square.phrase })
        }
      },
      sendChat(event) {
        if (this.chatMessage) {
          this.channel.push("new_chat_message", { body: this.chatMessage })
          this.chatMessage = ""
        }
      },
      joinChannel(authToken, gameName) {
        const socket =
          new Socket("/socket", { params: { token: authToken } })

        socket.connect()

        this.channel = socket.channel(`games:${gameName}`, {})

        this.channel.on("game_summary", summary => {
          this.squares = summary.squares
          this.scores = summary.scores
          this.winner = summary.winner
          this.players = this.toPlayers(this.presences)
        })

        this.presences = new Presence(this.channel);

        this.presences.onSync(() => {
          this.players = this.toPlayers(this.presences);
        });

        this.channel.on("new_chat_message", message => {
          this.messages.push(message)
        })

        this.channel.join()
          .receive("ok", response => {
            console.log(`Joined ${gameName} 😊`)
          })
          .receive("error", response => {
            this.error = `Joining ${gameName} failed 🙁`
            console.log(this.error, response)
          })
      },
      toPlayers(presences) {
        const listBy = (name, { metas: [first, ...rest] }) => {
          const score = this.scores[name] || 0
          return { name: name, color: first.color, score: score }
        }

        return presences.list(listBy);
      }
    },
    mounted() {
      const { authToken, gameName } = this.$el.dataset

      this.joinChannel(authToken, gameName)
    },
    watch: {
      messages(newValue, oldValue) {
        this.$nextTick(() => {
          // DOM is now updated
          const messageList = this.$refs.messages
          messageList.scrollTop = messageList.scrollHeight
        })
      }
    }
  })
}
