module.exports = class Sample
  constructor:()->
    console.log 'constructor'
    $(window).load ()->
      console.log 'jquery loaddayo'