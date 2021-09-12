export const scrollable = {
  data() {
    return {
      requesting: false
    }
  },
  methods: {
    handleScroll() {
      const scrollHeight = Math.max(
        document.body.scrollHeight, document.documentElement.scrollHeight,
        document.body.offsetHeight, document.documentElement.offsetHeight,
        document.body.clientHeight, document.documentElement.clientHeight
      );
      const pageMostBottom = scrollHeight - window.innerHeight;

      const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
      if (scrollTop + 180 >= pageMostBottom) {
        this.fetchNextPage()
      }
    }
  },
}