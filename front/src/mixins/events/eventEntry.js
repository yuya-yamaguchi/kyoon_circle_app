import axios from 'axios';
import g from "@/variable/variable.js";

export const eventEntry = {
  methods: {
    postEventEntry: function() {
      axios.post(
        `http://${g.hostName}/api/events/${this.$route.params.id}/entry`,
        {
          user_id: this.$store.getters['user/id']
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.$emit('update-entry-status', true, response.data.entry_users)
      })
      .catch((error) => {
        if (error.response.status === 400 || error.response.status === 401) {
          this.$store.dispatch(
            "flash/create",
            { message: error.response.data.error_message,
              type:    2
            }
          );
          if (error.response.status === 401) {
            this.$store.dispatch(
              "loginGuide/update", true
            );
          }
        }
        this.apiErrors(error.response.status);
      });
    },
  }
}