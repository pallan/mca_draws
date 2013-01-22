# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#rink_select').change (event) ->
    $('section.draw').hide();
    $('.table > tbody > tr').each (index,row) =>
      if ($(row).text().indexOf($(this).val()) == -1)
        $(row).hide()
      else
        $(row).show()
        $(row).parents('section.draw').show()
        
