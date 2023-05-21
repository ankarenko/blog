var firebaseApp = firebase.initializeApp({
  apiKey: "AIzaSyARpCnbeALb4Us7ZblZddt9XHB-aOCAC-0",
  authDomain: "ankarenko-live.firebaseapp.com",
  projectId: "ankarenko-live",
  storageBucket: "ankarenko-live.appspot.com",
  messagingSenderId: "629175953662",
  appId: "1:629175953662:web:3577258929d041e7025daf"
});
var db = firebaseApp.firestore();

var href = window.location.href
var postId = href.substring(href.lastIndexOf('/') + 1)

function sendComment() {
  const text = document.getElementById('comment-field').value;

  db.collection("comments").add({
    author: 'Anon',
    post_id: postId,
    data: text,
    timestamp: parseInt(Date.now())
  })
  .then((docRef) => {
    console.log("Document written with ID: ", docRef.id);
  })
  .catch((error) => {
    console.error("Error adding document: ", error);
  });
}

document.addEventListener("DOMContentLoaded", function () {
  var elBtn = document.getElementById("send-comment-btn");
  elBtn.addEventListener("click", sendComment);

  var elComments = document.getElementsByClassName("comments")[0];
  var commentsRef = db
  .collection("comments")
  .where("post_id", "==", postId)
  //.orderBy("timestamp", "des");

  var elCommentsContainer = document.getElementsByClassName("comments-container")[0];

  commentsRef
  .get()
  .then(function (res) {
    elComments.innerHtml = '';
    elComments.textContent = '';

    res.docs.forEach(function (doc) {
      var comment = Object.assign({ id: doc.id }, doc.data());
      var el = document.createElement('div');
      el.textContent = comment.author + ' : ' + comment.data;
      elComments.appendChild(el);
    });
  })
  .catch(function (err) {
    console.log(err)
    elCommentsContainer.innerHtml = '';
    elCommentsContainer.textContent = '';
  })

});


function timeStamp() {
  var now = new Date();
  var date = [now.getMonth() + 1, now.getDate(), now.getFullYear()];
  var time = [now.getHours(), now.getMinutes()];
  var suffix = (time[0] < 12) ? "AM" : "PM";
  time[0] = (time[0] < 12) ? time[0] : time[0] - 12;

  for (var i = 1; i < 3; i++) {
    if (time[i] < 10) {
      time[i] = "0" + time[i];
    }
  }

  return date.join("/") + ", " + time.join(":") + " " + suffix;
}

