const search = instantsearch({
  appId: "XFCG362Z75",
  apiKey: "6186ce8471876f278bd52f35912b99c2",
  indexName: "project_CRUD",
  routing: true
});

  
// initialize RefinementList
search.addWidget(
    instantsearch.widgets.refinementList({
    container: '#refinement-list',
    attributeName: 'categories'
    })
);

// initialize SearchBox
search.addWidget(
    instantsearch.widgets.searchBox({
      container: '#search-box',
      placeholder: 'Search for products'
    })
  );

search.addWidget(
  instantsearch.widgets.hits({
    container: "#hits",
    templates: {
      empty: "No results",
      item: '<em>Hit {{objectID}}</em>: {{{_highlightResult.name.value}}}'
    }
  })
);

search.start();
