require 'pixi.js'

module.exports = class App
  constructor:()->
    @renderer = null
    @stage = null
    @image = null
    @width = null
    @height = null

    @init()
  init:()->
    @width = $(window).width()
    @height = $(window).height()
    @renderer = new PIXI.WebGLRenderer(@width,@height)
    @stage = new PIXI.Container()
    document.body.appendChild(@renderer.view)

    console.log @stage


    @load()
    .then @animate()



  load:()->
    d = new $.Deferred
    PIXI.loader.add('image','/assets/images/image.jpg')
    .load (loader,resources)=>
      @image = new PIXI.Sprite(resources.image.texture)
      @image.position.x = 0
      @image.position.y = 100

      @image.scale.x = 1.0
      @image.scale.y = 1.2

      @stage.addChild(@image)

      d.resolve()
    return d.promise()

  animate:()=>
    requestAnimationFrame(@animate)
    # @image.rotation += 0.01
    @renderer.render(@stage)