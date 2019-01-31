module ApplicationHelper
  # override kaminari's code
  def page_entries_info(collection, entry_name: nil)
    entry_name = if entry_name
                   entry_name.pluralize(collection.size, I18n.locale)
                 else
                   collection.entry_name(count: collection.size).downcase
                 end

    if collection.total_pages < 2
      t('helpers.page_entries_info.one_page.display_entries', entry_name: entry_name, count: collection.total_count)
    else
      from = collection.offset_value + 1
      to   = collection.offset_value + collection.to_a.size

      t('helpers.page_entries_info.more_pages.display_entries', entry_name: entry_name.titleize, first: from, last: to, total: collection.total_count.to_s(:delimited))
    end.html_safe
  end
end
