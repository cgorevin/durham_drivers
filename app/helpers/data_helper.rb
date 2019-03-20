module DataHelper
  def bilevel_data
    {
      name: 'offenses',
      children: [
        {
          name: 'approved',
          children: [
            {
              name: 'unnotified',
              size: @approved_unnotified
            },
            {
              name: 'notified',
              size: @approved_notified
            }
          ]
        },
        {
          name: 'denied',
          children: [
            {
              name: 'unnotified',
              size: @denied_unnotified
            },
            {
              name: 'notified',
              size: @denied_notified
            }
          ]
        },
        {
          name: 'pending',
          children: [
            {
              name: 'unnotified',
              size: @pending_unnotified
            },
            {
              name: 'notified',
              size: @pending_notified
            }
          ]
        },
        {
          name: 'pulled',
          children: [
            {
              name: 'unnotified',
              size: @pulled_unnotified
            },
            {
              name: 'notified',
              size: @pulled_notified
            }
          ]
        }
      ]
    }.to_json.html_safe
  end
end
