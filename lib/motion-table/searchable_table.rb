module MotionTable
  module SearchableTable
    def makeSearchable(params={})
      params[:frame] ||= CGRectMake(0, 0, 320, 44)
      params[:contentController] ||= self
      params[:delegate] ||= self
      params[:searchResultsDataSource] ||= self
      params[:searchResultsDelegate] ||= self

      searchBar = UISearchBar.alloc.initWithFrame(params[:frame])

      @contactsSearchDisplayController = UISearchDisplayController.alloc.initWithSearchBar(searchBar, contentsController: params[:contentController])
      @contactsSearchDisplayController.delegate = params[:delegate]
      @contactsSearchDisplayController.searchResultsDataSource = params[:searchResultsDataSource]
      @contactsSearchDisplayController.searchResultsDelegate = params[:searchResultsDelegate]
      
      self.tableView.tableHeaderView = searchBar
    end

    def searchDisplayController(controller, shouldReloadTableForSearchString:searchString)
      @mt_table_view_groups = []

      @original_data.each do |section|
        newSection = {}
        newSection[:cells] = []

        section[:cells].each do |cell|
          if cell[:title].to_s.downcase.strip.include?(searchString.downcase.strip)
            newSection[:cells] << cell
          end
        end

        if newSection.count > 0
          newSection[:title] = section[:title]
          @mt_table_view_groups << newSection
        end
      end
      true
    end

    def searchDisplayControllerWillEndSearch(controller)
      @mt_table_view_groups = @original_data.clone
      @original_data = nil
    end

    def searchDisplayControllerWillBeginSearch(controller)
      @original_data = @mt_table_view_groups.clone
    end
  end
end