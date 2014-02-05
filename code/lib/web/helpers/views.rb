require 'uri'

helpers do
  def partial name
    haml :"partial/#{name.to_s}"
  end

  def options_from catalog
    html = ''
    catalog.each do |item|
      selected = item.selected? ? 'selected="selected" ' : ''
      html += haml("%option(#{selected}value='#{item.value}') #{item.name}")
    end
    html
  end

  def mail_link to, opts={}
    return nil if to.nil?

    subject = opts[:subject].nil? ? '' : URI.escape(opts[:subject])
    copy_to = opts[:copy_to].nil? ? '' : opts[:copy_to]
    body = opts[:body].nil? ? '' : URI.escape(opts[:body])
    "mailto:#{to}?subject=#{subject}&cc=#{copy_to}&body=#{body}"
  end
end
