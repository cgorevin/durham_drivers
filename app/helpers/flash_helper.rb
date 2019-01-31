module FlashHelper
  def alert_generator(msg, alert = 'alert-danger')
    <<~HTML
      <div class="alert #{alert} alert-dismissable"><a class="close" data-dismiss="alert"></a>#{msg}</div>
    HTML
  end

  def flash_helper
    return '' unless flash.present?

    msgs = flash.map do |name, msg|
      alert = name == 'notice' ? 'alert-success' : 'alert-danger'
      alert_generator msg, alert
    end

    msgs.join.html_safe
  end
end
