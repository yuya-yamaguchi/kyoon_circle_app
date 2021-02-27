import axios from 'axios';
import g from "@/variable/variable.js";
import { errorMethods } from '@/mixins/errorMethods';

export const userFollow = {
  mixins: [errorMethods],
  data() {
    return {
      selectUserNo: 0,
      isList: false
    }
  },
  methods: {
    follow(user) {
      axios.post(
        `http://${g.hostName}/api/relationships`,
        {
          followed_id: user.id
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then(() => {
        if (this.isList) {
          // リストからフォロー用
          this.followUsers[this.selectUserNo].is_followed = true;
        }
        else {
          // ユーザ詳細画面からフォロー用
          this.isFollowed = true;
          this.user.followers_count++;
        }
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
    },
    followInList(i) {
      this.selectUserNo = i;
      this.isList = true;
      this.follow(this.followUsers[i]);
    },
    unfollow(user) {
      if(window.confirm('フォローを外してよろしいですか？')) {
        axios.delete(
          `http://${g.hostName}/api/relationships/${user.id}`,
          {
            headers: {
              Authorization: this.$store.getters['user/secureToken']
            }
          }
        )
        .then(() => {
          if (this.isList) {
            // リストからフォロー解除したとき用
            this.followUsers[this.selectUserNo].is_followed = false;
          }
          else {
            // ユーザ詳細画面からフォロー解除したとき用
            this.isFollowed = false;
            this.user.followers_count--;
          }
        })
        .catch((error) => {
          this.apiErrors(error.response.status);
        })
      }
    },
    unfollowInList(i) {
      this.selectUserNo = i;
      this.isList = true;
      this.unfollow(this.followUsers[i]);
    }
  }
}