//= require rails-ujs
//= require jquery
//= require popper
//= require bootstrap/util
//= require bootstrap/button
//= require bootstrap/tooltip
//= require turbolinks
//= require_tree .

// we only need bootstrap/button on pages with 'data-toggle="buttons"''
// we only need bootstrap/tooltip on pages with 'data-toggle="tooltip"' (contacts#show, offenses#show) (maybe we could remove tooltips)
// we only need popper on pages on pages with 'data-toggle="tooltip"'' (contacts#show, offenses#show) (maybe we could remove tooltips)
// tooltips are only used on admin pages
