let hostName = "";
if (location.hostname == "localhost") {
  hostName = "localhost:3000"
}
else
{
  hostName = "18.177.101.206:3000"
}

export default {
  hostName
}
