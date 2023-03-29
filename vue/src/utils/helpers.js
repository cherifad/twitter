function formatCount(views) {
  if (views < 1000) {
    return views.toString();
  } else if (views >= 1000 && views < 1000000) {
    return (views / 1000).toFixed(1) + "K";
  } else if (views >= 1000000 && views < 1000000000) {
    return (views / 1000000).toFixed(1) + "M";
  } else {
    return (views / 1000000000).toFixed(1) + "B";
  }
}

function timeSince(date) {
  date = new Date(date);
  var seconds = Math.floor((new Date() - date) / 1000);

  var interval = seconds / 31536000;

  if (interval > 1) {
    return Math.floor(interval) + "Y";
  }
  interval = seconds / 2592000;
  if (interval > 1) {
    return Math.floor(interval) + "M";
  }
  interval = seconds / 86400;
  if (interval > 1) {
    return Math.floor(interval) + "d";
  }
  interval = seconds / 3600;
  if (interval > 1) {
    return Math.floor(interval) + "h";
  }
  interval = seconds / 60;
  if (interval > 1) {
    return Math.floor(interval) + "min";
  }
  return Math.floor(seconds) + "sec";
}

function extractHashTags(text) {
  return text.match(/#[a-zA-Z0-9]+/g);
}

export { formatCount, timeSince, extractHashTags };
