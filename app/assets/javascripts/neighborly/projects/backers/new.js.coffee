Neighborly.Projects = {} if Neighborly.Projects is undefined
Neighborly.Projects.Backers = {} if Neighborly.Projects.Backers is undefined

Neighborly.Projects.Backers.New =
  modules: -> []

  init: Backbone.View.extend
    el: '.new-backer-page'

    initialize: ->
      _.bindAll this, 'resetReward', 'clickReward', 'clickAnonymous'

      # bind change event (support for ie8 )
      this.$('#backer_value').change this.resetReward
      this.$('input[type=radio]').change this.clickReward
      this.$('#backer_anonymous').change this.clickAnonymous

      this.$value = this.$('#backer_value')
      this.rewards = this.$value.data('rewards')
      this.$choices = this.$('.reward-option')
      this.selectReward(this.$('input[type=radio]:checked'))
      this.$value.focus()
      this.submitButtonHandler()

    submitButtonHandler: ->
      if this.$value[0].checkValidity()
        this.$('input[type=submit]').removeClass('disable').attr('disabled', false)
      else
        this.$('input[type=submit]').addClass('disable').attr('disabled', true)

    clickAnonymous: ->
      this.$('.anonymous-warning').fadeToggle()
      this.submitButtonHandler()

    clickReward: (event) ->
      this.$choices.removeClass('selected')
      option = this.$(event.currentTarget)
      reward = this.reward()
      this.$('.custom.radio.checked').not(option.find('~ span')).removeClass('checked')
      this.selectReward option
      this.$value.val(reward.minimum_value) if this.$value.val() == '' || parseInt(this.$value.val()) < parseInt(reward.minimum_value)
      option.parents('.reward-option:first').addClass('selected')
      this.submitButtonHandler()

    reward: ->
      $reward = this.$('input[type=radio]:checked')
      if $reward.length > 0
        reward = {}
        for r in this.rewards
          reward = r if parseInt(r.id) is parseInt($reward.val())

        return reward

    selectReward: ($reward) ->
      $reward.prop 'checked', true
      this.$('.custom.radio.checked').removeClass('checked')
      $reward.find('~ span').addClass('checked')

    resetReward: (event) ->
      reward = this.reward()
      if reward
        value = this.$value.val()
        this.selectReward(this.$('#backer_reward_id')) if (!(/^(\d+)$/.test(value))) || (parseInt(value) < parseInt(reward.minimum_value))
      this.submitButtonHandler()

