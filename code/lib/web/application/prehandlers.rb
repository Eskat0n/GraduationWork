before :not => '/system/state' do
  redirect to('/system/state') unless SHR::Consistency.consistent?
end

before :not => '/logon' do
  redirect to('/logon') unless authorized?
end
  
before do
  if SHR::Consistency.warnings? and settings.display_warnings
    @warnings_count_popup = SHR::Consistency.warnings.size
    disable :display_warnings
  end
end