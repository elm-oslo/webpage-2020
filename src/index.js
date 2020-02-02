import lottie from "lottie-web";

import "./styles.css";
import { Elm } from "./Main.elm";
import initAnimation from "./animation/main";

var app = Elm.Main.init({
  node: document.getElementById("root")
});

// -----

HTMLElement.prototype.addClass = function(add) {
  if (/open/.test(this.className)) return;

  this.className = this.className + " " + add;
};

HTMLElement.prototype.removeClass = function(remove) {
  var newClassName = "";
  var i;
  var classes = this.className.split(" ");
  for (i = 0; i < classes.length; i++) {
    if (classes[i] !== remove) {
      newClassName += classes[i] + " ";
    }
  }
  this.className = newClassName;
};

let ticketBtnAnimation;

app.ports.init.subscribe(function() {
  ticketBtnAnimation = lottie.loadAnimation({
    container: document.getElementById("ticket_btn_animation"),
    renderer: "svg",
    autoplay: false,
    loop: false,
    path: "7434-confetti.json",
    rendererSettings: {
      viewBoxOnly: false
    }
  });

  setTimeout(function() {
    var nodes = document.querySelectorAll(".animate");
    for (var i = 0; i < nodes.length; i++) {
      var node = nodes[i];
      if (node.addClass) node.addClass("animate-start");
      else node.className += "animate-start";
    }
  }, 300);

  // Load the background animation
  try {
    initAnimation();
  } catch (e) {
    console.warning && console.warning("init animation failed", e);
  }
});

app.ports.scrollToId.subscribe(function(id) {
  requestAnimationFrame(function() {
    document.getElementById(id).scrollIntoView();
  });
});

app.ports.startBuyTicketAnim.subscribe(function() {
  ticketBtnAnimation.goToAndPlay(0, true);
});
app.ports.stopBuyTicketAnim.subscribe(function() {
  ticketBtnAnimation.goToAndStop(1, true);
});
