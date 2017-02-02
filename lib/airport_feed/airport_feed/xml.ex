defmodule XML do
  import Record, only: [defrecord: 2, extract: 2]
  require Logger
  
  defrecord :xmlElement, extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  defrecord :xmlText, extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  
  def get_text({document, _}, xpath) do
    Logger.debug "xpath: #{xpath}"
    
    [path_string] = :xmerl_xpath.string(xpath, document)
    [content] = xmlElement(path_string, :content)
    xmlText(content, :value)
  end
end