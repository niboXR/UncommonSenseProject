document.addEventListener("DOMContentLoaded", function() {
  const flipCards = document.querySelectorAll('.flip-card');

  flipCards.forEach(card => {
    card.addEventListener('mouseenter', function() {
      const backHeight = this.querySelector('.flip-card-back').offsetHeight;
      this.style.marginBottom = (backHeight - 300) + 'px';
    });

    card.addEventListener('mouseleave', function() {
      this.style.marginBottom = '0';
    });
  });
});

