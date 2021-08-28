function createNotification(notification) {
    new Notification(`Radiopush: ${notification.title}`, { body: notification.body, icon: notification.img });
}

function notifyMe(notification) {
    if (!("Notification" in window)) {
    }

    else if (Notification.permission === "granted") {
        createNotification(notification)
    }

    else if (Notification.permission !== "denied") {
        Notification.requestPermission().then(function (permission) {
            if (permission === "granted") {
                createNotification(notification)
            }
        });
    }

}

export const Notify = {
    mounted() {
        if ("Notification" in window) {
            Notification.requestPermission()
        }

        this.handleEvent("notify", ({ notification }) => {
            notifyMe(notification)
        })

    }

}