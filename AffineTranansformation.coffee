class AffineTranansformation
  constructor: (topLeft, topRight, bottomRight, bottomLeft) ->
    @ref0 = [0,0] # upper left corner
    @ref1 = [0,1] # lower left corner
    @ref2 = [1,0] # upper right corner
    @ref3 = [1,1] # lower right corner

    @tomap0 = [topLeft.x, topLeft.y] # upper left corner
    @tomap1 = [bottomLeft.x, bottomLeft.y] # lower left corner
    @tomap2 = [topRight.x, topRight.y] # upper right corner
    @tomap3 = [bottomRight.x, bottomRight.y] # lower right corner

    @calculateDivider()

  calculateDivider: ->
    result = (@tomap0[0] - (@tomap2[0])) * (@tomap1[1] - (@tomap2[1])) - ((@tomap1[0] - (@tomap2[0])) * (@tomap0[1] - (@tomap2[1])))
    if result == 0.0
    else
      @divider = result
      @calculateAn()
      @calculateBn()
      @calculateCn()
      @calculateDn()
      @calculateEn()
      @calculateFn()
    result

  calculateAn: ->
    result = (@ref0[0] - (@ref2[0])) * (@tomap1[1] - (@tomap2[1])) - ((@ref1[0] - (@ref2[0])) * (@tomap0[1] - (@tomap2[1])))
    @an = result
    result

  calculateBn: ->
    result = (@tomap0[0] - (@tomap2[0])) * (@ref1[0] - (@ref2[0])) - ((@ref0[0] - (@ref2[0])) * (@tomap1[0] - (@tomap2[0])))
    @bn = result
    result

  calculateCn: ->
    result = (@tomap2[0] * @ref1[0] - (@tomap1[0] * @ref2[0])) * @tomap0[1] + (@tomap0[0] * @ref2[0] - (@tomap2[0] * @ref0[0])) * @tomap1[1] + (@tomap1[0] * @ref0[0] - (@tomap0[0] * @ref1[0])) * @tomap2[1]
    @cn = result
    result

  calculateDn: ->
    result = (@ref0[1] - (@ref2[1])) * (@tomap1[1] - (@tomap2[1])) - ((@ref1[1] - (@ref2[1])) * (@tomap0[1] - (@tomap2[1])))
    @dn = result
    result

  calculateEn: ->
    result = (@tomap0[0] - (@tomap2[0])) * (@ref1[1] - (@ref2[1])) - ((@ref0[1] - (@ref2[1])) * (@tomap1[0] - (@tomap2[0])))
    @en = result
    result

  calculateFn: ->
    result = (@tomap2[0] * @ref1[1] - (@tomap1[0] * @ref2[1])) * @tomap0[1] + (@tomap0[0] * @ref2[1] - (@tomap2[0] * @ref0[1])) * @tomap1[1] + (@tomap1[0] * @ref0[1] - (@tomap0[0] * @ref1[1])) * @tomap2[1]
    @fn = result
    result

  deriveMappingCoords: (point) ->
    if @divider != 0
      {
        x: (@an * point[0] + @bn * point[1] + @cn) / @divider
        y: (@dn * point[0] + @en * point[1] + @fn) / @divider
      }

module.exports = AffineTranansformation
