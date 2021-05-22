let scrollAt = () => {
    let scrollTop = document.documentElement.scrollTop || document.body.scrollTop
    let scrollHeight = document.documentElement.scrollHeight || document.body.scrollHeight
    let clientHeight = document.documentElement.clientHeight

    return scrollTop / (scrollHeight - clientHeight) * 100
}

export const InfiniteScroll = {
    mounted() {
        window.addEventListener("scroll", e => {
            if (scrollAt() > 90) {
                this.pushEvent("load-more", {})
            }
        })
    }
}