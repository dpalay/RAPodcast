class RedirectRoutingController < ActionController::Base
  def redirect
    args, options = params[:args] || [], {}
    options = params[:args].pop if Hash === params[:args].last
    response.headers["Status"] = "301 Moved Permanently" if options.delete(:permanent)
    raise ArgumentError, "too many arguments" if args.size > 1
    redirect_to args.empty? ? options : args.first
  end
end