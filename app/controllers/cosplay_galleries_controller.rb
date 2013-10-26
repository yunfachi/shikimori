# TODO: вынести всё в cosplay_controller(когда решу отобразить косплей на сайте) и выпилить этот контроллер
class CosplayGalleriesController < ApplicationController
  # все косплееры
  def index
    set_meta_tags noindex: true, nofollow: true
    @title = 'Косплей'
    #@cosplayers = Cosplayer.select('cosplayers.*, count(*) as galleries_num').
                            #joins(:cosplay_galleries).
                            #group('cosplayers.id').
                            ##having('galleries_num > 10').
                            #order('galleries_num desc, name').
                            #limit(20)

    cosplayer_ids = []
    ActiveRecord::Base.connection.
                       execute("select c.id, count(distinct(cg.id))
                                     from cosplayers c
                                        inner join cosplay_gallery_links cgl
                                            on cgl.linked_id = c.id and cgl.linked_type='Cosplayer'
                                        inner join cosplay_galleries cg
                                            on cgl.cosplay_gallery_id = cg.id
                                     where
                                         cg.type = 'CosplaySession' and cg.deleted = 0
                                     group by c.id
                                     having
                                         count(cg.id) >= 6").
                       each {|v| cosplayer_ids << v[0] }

    @cosplayers = Cosplayer.where(id: cosplayer_ids.shuffle.take(6))#.
                            #includes(cosplay_galleries: :images)#.
                            #order(:name)

    @gallery_index_map = @cosplayers
    @gallery = @cosplayers.map {|v| v.cosplay_galleries.shuffle.take(6) }
  end

  # один косплеер
  def show
    set_meta_tags noindex: true, nofollow: true
    @chronology_window ||= 5

    @cosplayer = Cosplayer.find(params[:cosplayer].to_i)
    if params[:gallery]
      @gallery = CosplaySession.find(params[:gallery].to_i)
    else
      @gallery = @cosplayer.cosplay_galleries.order('rand()').limit(1).first
    end

    if params[:gallery] && @gallery.to_param != params[:gallery]
      redirect_to cosplayer_path(@cosplayer, @gallery), status: :moved_permanently and return
    end
    if @cosplayer.to_param != params[:cosplayer]
      if params[:gallery]
        redirect_to cosplayer_path(@cosplayer, @gallery), status: :moved_permanently and return
      else
        redirect_to @cosplayer, status: :moved_permanently and return
      end
    end

    @chronology = chronology(window: @chronology_window,
                             source: @cosplayer.cosplay_galleries,
                             date: :date,
                             entry: @gallery)

    #debug(@gallery.images.count)
    #debug(CosplaySession.where(:date.gteq => @gallery.date).limit(1).debug_sql)

    @title = "%s косплеит %s" % [@cosplayer.name, @gallery.target]
  end

  # комментарии к галлереи косплея
  def comments
    if params[:gallery]
      @gallery = CosplaySession.find(params[:gallery].to_i)
    else
      @gallery = @cosplayer.cosplay_galleries.order('rand()').limit(1).first
    end

    render text: render_to_string(partial: 'comments/comments.html.erb', locals: {object: @gallery})
  end
end
