class NotesController < ApplicationController
  expose(:need)

  expose(:notes, model: :activity_item, ancestor: :need)
  expose(:note)

  def create
    authorize! :create, Note

    note.assign_attributes(
      item_type: 'note',
      user: current_user,
      data: {
        body: params[:note][:body]
      }
    )

    if note.save
      flash.notice = "Note saved"
    else
      flash.alert = "Note must not be blank"
    end

    redirect_to need_activity_items_path(need)
  end
end
