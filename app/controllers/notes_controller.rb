class NotesController < ApplicationController
  
  def index
    @notes = Note.all(:conditions => 'finished_at IS NOT NULL', :order => 'finished_at DESC')
    @open_notes = Note.all(:order => 'finished_at DESC')
  end
  
end
