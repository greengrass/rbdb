class TablesController < ApplicationController
  before_filter :select_db
  before_filter :select_table, :only => [:show]
  
  layout 'table'
  
  def show
    session[:mode] ||= 'structure'
    session[:mode] = params[:mode] if params[:mode]
    session[:per_page] = params[:per_page].to_i if params.has_key? :per_page
    session[:per_page] = 30 if session[:per_page].to_i <= 0
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @order = params[:order]
    if session[:mode] == 'browse'
      @rows = @table.ar_class.paginate :page => @page, :per_page => session[:per_page],
        :order => @order
    else
      @relations = Relation.has_many(@table, @datab)  
    end
    @columns = @table.columns
    store_table(@table)
    render :action => session[:mode]
  end
  
  def new
    @table = Table.new
  end
  
  def create
    if @table.create params[:table], @datab
      flash[:notice] = "Table #{@table.name} was successfully created."
      redirect_to datab_table_path(@datab, @table)
    else
      render :action => "new"
    end
  end

  private
  MAX_STORED_TABLES = 3
  def store_table(table)
    add_to_session :last_tables, {:name => table.name, :db => @datab.name}, MAX_STORED_TABLES
  end
    
end
