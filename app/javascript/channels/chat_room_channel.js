import consumer from "./consumer";

let chatRoomChannel;

document.addEventListener("turbo:load", () => {
  const chatRoomContainer = document.getElementById("chat-room-messages");

  if (chatRoomContainer) {
    const chatRoomId = chatRoomContainer.dataset.chatRoomId;

    chatRoomChannel = consumer.subscriptions.create(
      { channel: "ChatRoomChannel", id: chatRoomId },
      {
        connected() {
          console.log("✅ Connected to ChatRoomChannel");
        },

        disconnected() {
          console.log("❌ Disconnected from ChatRoomChannel");
        },

        received(data) {
          // Append the new message HTML
          chatRoomContainer.insertAdjacentHTML("beforeend", data.html);
          chatRoomContainer.scrollTop = chatRoomContainer.scrollHeight;
        },
      }
    );
  }
});
