Neighborly.Projects = {} if Neighborly.Projects is undefined

Neighborly.Projects.modules =-> [Neighborly.Tabs, Neighborly.Rewards.Index, Neighborly.Projects.Show.StatusBar]

Neighborly.Projects.Show =
  init: Backbone.View.extend
    el: '.project-page'

    initialize: ->

  StatusBar: Backbone.View.extend
    el: '.project-page'

    events:
      'click .scroll-to-top': 'scrollTop'

    initialize: ->
      return if this.$el.length is 0
      offset = this.$('.status-bar').offset()
      offset = offset.top if offset?
      $(window).unbind('scroll')
      $(window).scroll ->
        if $(document).scrollTop() > offset
          this.$('.status-bar').addClass('fixed')
        else
          this.$('.status-bar').removeClass('fixed')

    scrollTop: (event)->
      event.preventDefault()
      $(document).scrollTop(0)
