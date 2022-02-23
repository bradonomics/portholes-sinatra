// Sub-menu toggler (desktop)
document.querySelector('.sub-menu-toggle').addEventListener('click', function(event) {
  event.preventDefault();
  subMenuToggler();
});

// Clicking off the menu closes menu
document.addEventListener('click', function(event) {
  if (event.target != document.querySelector('.sub-menu-toggle') && event.target != document.querySelector('.sub-menu')) {
    closeNavigation();
  }
});

// Pressing Esc closes menu
document.onkeydown = function(event) {
  if (event.keyCode == 27) {
    closeNavigation();
  }
};

// Sub-menu toggler (desktop)
function subMenuToggler() {

  // Get the sub-menu
  var subNavigation = document.querySelector('.sub-menu');
  // Get the sub-menu-toggler
  var toggler = document.querySelector('.sub-menu-toggle');

  if (subNavigation.getAttribute('data-collapsed') == 'true') {
    openNavigation();
    return false;
  }

  if (subNavigation.getAttribute('data-collapsed') == 'false') {
    closeNavigation();
    return false;
  }

}

function openNavigation() {
  // Get the sub-menu
  var subNavigation = document.querySelector('.sub-menu');
  // Get the sub-menu-toggler
  var toggler = document.querySelector('.sub-menu-toggle');

  // Add class `expanded` to .sub-menu
  subNavigation.className += ' expanded';

  // Add class `expanded` to .sub-menu-toggle
  toggler.className += ' expanded';

  // set data-collapsed to false
  subNavigation.setAttribute('data-collapsed', 'false');
}

function closeNavigation() {
  // Get the sub-menu
  var subNavigation = document.querySelector('.sub-menu');
  // Get the sub-menu-toggler
  var toggler = document.querySelector('.sub-menu-toggle');

  // Remove expanded class from .sub-menu
  subNavigation.classList.remove('expanded');

  // Remove expanded class from .sub-menu-toggler
  toggler.classList.remove('expanded');

  // mark the section as collapsed
  subNavigation.setAttribute('data-collapsed', 'true');

}
