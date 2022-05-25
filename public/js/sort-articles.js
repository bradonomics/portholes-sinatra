var sortable = Sortable.create(document.getElementById('articles'), {
  handle: '.sort',
  animation: 100,
  ghostClass: 'moving-background',

  onEnd: function(event) { // element dragging ended

    var articleIds = [];
    document.querySelectorAll('.article').forEach(function(item) {
      articleIds.push(item.dataset.id);
    });

    // fetch(window.location.href + '/sort', {
    //   method: 'patch',
    //   crossDomain: true,
    //   headers: {
    //     // 'Content-type': 'application/json'
    //     'Content-type': 'application/json; charset=UTF-8'
    //   },
    //   // body: 'articles=' + articleIds
    //   // body: 'articles=' + JSON.stringify(articleIds)
    //   body: JSON.stringify({
    //     articles: articleIds
    //   })
    // });

    // var request = new XMLHttpRequest();
    // request.open('patch', window.location.href + '/sort');
    // request.send('articles=' + articleIds);

    $.ajax({
      url: window.location.href + '/sort',
      type: 'patch',
      data: 'articles=' + articleIds
    });

  }

});
