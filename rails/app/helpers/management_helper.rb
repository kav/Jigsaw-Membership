module ManagementHelper
  def ensure_authed
    ensure_access_token
    ensure_user
  end
  def ensure_access_token
    if params.has_key?(:code)
      session[:]
end
