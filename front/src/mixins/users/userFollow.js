import axios from 'axios';
import g from "@/variable/variable.js";
import { errorMethods } from '@/mixins/errorMethods';

export const userFollow = {
  mixins: [errorMethods],
  methods: {
    follow() {
      axios.post(
        `http://${g.hostName}/api/relationships`,
        {
          followed_id: this.$route.params.id
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then(() => {
        this.isFollowed = true
        this.user.followers_count++;
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
    },
    unfollow() {
      if(window.confirm('フォローを外してよろしいですか？')) {
        axios.delete(
          `http://${g.hostName}/api/relationships/${this.$route.params.id}`,
          {
            headers: {
              Authorization: this.$store.getters['user/secureToken']
            }
          }
        )
        .then(() => {
          this.isFollowed = false;
          this.user.followers_count--;
        })
        .catch((error) => {
          this.apiErrors(error.response.status);
        })
      }
    }
  }
}