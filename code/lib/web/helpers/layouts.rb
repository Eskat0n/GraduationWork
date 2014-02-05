# coding: utf-8

helpers do
  def layouted name, layout, title, opts
    haml name, :layout => layout, :locals => { :title => title }.merge(opts)
  end

  def overview name, title, opts={}
    layouted name, :_overview, title, opts
  end

  def details name, title, opts={}
    layouted name, :_details, title, { :backlink_href => to('/'), :backlink_text => 'На главную' }.merge(opts)
  end

  def help name, title, opts={}
    layouted name, :_help, title, opts
  end

  def message title, text, opts={}
    haml :message, :locals => { :title => title, :text => text }.merge(opts)
  end
end