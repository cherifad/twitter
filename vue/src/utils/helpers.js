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

function extractMentions(text) {
  return text.match(/@[a-zA-Z0-9]+/g);
}

function formatDate(dateParam) {
  const date = new Date(dateParam);
  const today = new Date();
  const yesterday = new Date(today);
  yesterday.setDate(today.getDate() - 1);

  const isToday = date.getDate() === today.getDate()
    && date.getMonth() === today.getMonth()
    && date.getFullYear() === today.getFullYear();

  const isYesterday = date.getDate() === yesterday.getDate()
    && date.getMonth() === yesterday.getMonth()
    && date.getFullYear() === yesterday.getFullYear();

  const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  const month = monthNames[date.getMonth()];
  const day = date.getDate();
  const year = date.getFullYear();

  const time = date.toLocaleTimeString([], {hour: 'numeric', minute: '2-digit'});
  const meridian = time.slice(-2);
  const formattedTime = time.slice(0, -3) + ':' + meridian;

  if (isToday) {
    return 'Today, ' + formattedTime;
  } else if (isYesterday) {
    return 'Yesterday, ' + formattedTime;
  } else {
    return `${month} ${day}, ${year}, ${formattedTime}`;
  }
}

function convertDate(dateString) {
  console.log(dateString);
  const parts = dateString.split("-"); // split the string into an array of year, month, and day parts
  const year = parseInt(parts[0], 10); // extract year and convert it to a number
  const month = parseInt(parts[1], 10) - 1; // extract month and convert it to a number (subtract 1 as month is zero-indexed)
  const day = parseInt(parts[2], 10); // extract day and convert it to a number
  const date = new Date(year, month, day); // create a Date object using the extracted year, month, and day
  return date
}

export { formatCount, timeSince, extractHashTags, formatDate, convertDate, extractMentions };
