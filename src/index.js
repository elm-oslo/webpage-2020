import "./styles.css";
import { Elm } from "./Main.elm";
import initAnimation from "./animation/main";

import lottie from "lottie-web";

var app = Elm.Main.init({
  node: document.getElementById("root")
});

console.log(app);

///

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

let ticket_btn_anim;

const ticketAnimName = "ticket-anim";

app.ports.init.subscribe(function() {
  ticket_btn_anim = lottie.loadAnimation({
    name: ticketAnimName,
    container: document.getElementById("ticket_btn_animation"),
    renderer: "svg",
    autoplay: false,
    loop: false,
    path: "7434-confetti.json",
    rendererSettings: {
      viewBoxOnly: false
    }
    // path: "ticket.json"
  });

  // ticket_btn_anim.play();

  // console.log("animation loaded", ticket_btn_anim);

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
  console.log("start anim", { ticket_btn_anim });
  ticket_btn_anim.goToAndPlay(0, true);
  // lottie.play(ticketAnimName);
  // ticket_btn_anim.play();
});
app.ports.stopBuyTicketAnim.subscribe(function() {
  ticket_btn_anim.goToAndStop(1, true);
  // lottie.
});
