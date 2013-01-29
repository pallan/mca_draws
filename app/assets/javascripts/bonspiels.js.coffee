# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#rink_select').change (event) ->
    $('.table > tbody > tr').each (index,row) =>
      if ($(row).text().indexOf($(this).val()) == -1)
        $(row).hide()
      else
        $(row).show()
  
  nearestUpperPow2 = (v) ->
    v--;
    v |= v >> 1;
    v |= v >> 2;
    v |= v >> 4;
    v |= v >> 8;
    v |= v >> 16;
    v |= v >> 32;
    return v += 1;

  build_bracket = (teams) ->
    pairings        = Math.ceil(teams.length)
    bracket_size    = nearestUpperPow2(teams[0].length*2)
    if ((bracket_size & (bracket_size-1)) == 0)
      power = Math.log(bracket_size) / Math.LN2
      game_number = 0
      x = 10
      y = 0
      spacing = 100
      height = 50
      offset = height / 2
      matches = bracket_size / 2
      width = 150
      paper = Raphael('bracket', (width*power)+200, (100*bracket_size/2)+40 )
      
      for j in [0..(power-1)] by 1
        y_loc = y + offset
        pairings = teams[j]
        for i in [0..(matches-1)] by 1
          console.log("Index: "+ i)
          if (pairings[i][1] == null) 
            pairings[i][1] = ''
          paper.path("M"+x+" "+y_loc+"l"+width+" 0l0 "+height+"l-"+width+" 0")
          paper.text(x+5, y_loc-7, '').attr({'font-size':12,'text-anchor':'start' })
          paper.text(x+5, y_loc-8, pairings[i][0]).attr({'font-size':12,'text-anchor':'start' })
          paper.text(x+5, y_loc+(height-8), pairings[i][1]).attr({'font-size':12,'text-anchor':'start' })
          paper.text(x+width-5, y_loc+(height/2), "Game #"+(game_number+1)).attr({'font-size':11,'text-anchor':'end' })
          y_loc += spacing
          game_number += 1
        offset = spacing / 2
        spacing *= 2
        height *= 2
        x += width
        matches = matches / 2

      height = height / 2
      paper.path("M"+x+" "+height+"l"+width+" 0")
      paper.text(x+5, height-8, teams[j][0]).attr({'font-size':12,'text-anchor':'start' })
   
  # build_bracket($('#bracket').data('rounds'))
  $("[data-gracket]").gracket();