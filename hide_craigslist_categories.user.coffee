###
//
// ==UserScript==
// @name          Hide Craigslist Categories
// @namespace     http://jkk.us/scripts
// @description     Hide Craigslist Categories with a Click. Link to reset filter at bottom of page.
// @include       http://*.craigslist.tld/*
// @require      http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js
// ==/UserScript==
//
###

###
A craigslist row:

<p class="row">
<span>
<a href="article url">
             (article title)
         (separator dash)
<font>
             (city)
<small class="gc">
<a href="category url">
                 (category title)
<br class="c">

###



$(document).ready () ->

     get_omitted_hrefs = () ->
         val = GM_getValue "omitted_hrefs"
         refs = if val?
                 val.split("\n")
             else
                 []
         return refs


     insert_omitted_href = (href) ->
         href = href.split('craigslist.org')[1]
         hrefs = get_omitted_hrefs()
         if href? and href != "" and href not in hrefs
             hrefs.push href
             GM_setValue "omitted_hrefs", hrefs.join('\n')

     clear_omitted_hrefs = () ->
         GM_deleteValue("omitted_hrefs")

     append_hide_button_to_category_link = (link) ->
         hide_button = $("<button>(Hide)</button>")
         hide_button.on "click", () ->
             insert_omitted_href link.href
             scan_page_and_hide_rows()
         hide_button.insertAfter link

     get_all_category_links_on_page = () ->
         $("p small.gc a")

     hide_category = (category_href) ->
         href_selector = "[href='" + category_href + "']"
         af = $(href_selector)
         af.closest('p').hide()

     scan_page_and_hide_rows = () ->
         omits = get_omitted_hrefs()
         $.each omits, (n, category_href) ->
             hide_category category_href
         return null

     reset_link = $("<button>(reset hide list)</button>")
     reset_link.on "click", () ->
         clear_omitted_hrefs()
         get_all_category_links_on_page().closest('p').show()
     reset_link.appendTo 'body'

     get_all_category_links_on_page().each (n,link) ->
             append_hide_button_to_category_link link

     scan_page_and_hide_rows()


