component {
	public any function init() {
		_setupMarkdownProcessor();
		_setupHtmlRenderer();
		_setupNoticeBoxRenderer();

		return this;
	}

	public string function markdownToHtml( required string markdown ) {
		var document = _getMarkdownProcessor().parse( arguments.markdown );
		var html = _getHtmlRenderer().render(document);
		return _getNoticeBoxRenderer().renderNoticeBoxes( html );
	}

// PRIVATE
	private void function _setupMarkdownProcessor() {
		var javaLib   = _getJavaLibs();
		var processor = CreateObject( "java", "com.vladsch.flexmark.parser.Parser", javaLib).builder().build();
		_setMarkdownProcessor( processor );
	}

	private void function _setupHtmlRenderer() {
		var javaLib   = _getJavaLibs();
		/*
			// declare parser emulation as "Markdown"
			var options = createObject("java", "com.vladsch.flexmark.util.options.MutableDataSet", javaLib);
			options.setFrom(parserEmulationProfile.MARKDOWN);
		*/

		// declare parser emulation as "commonMark"
		/* PK, January 19, 2018: chose this (default) setting, because there are quite a lot of existing templates
		 *   in this project which do not get parsed well when using Markdown profile (both with the new flexMark lib
		 *   AND the old PegDown lib)
		 *   eg. this would be seen as 1 line of text: "line 1
				 - line 2 supposed to be a bullet point line
				 - line 3 supposed to be a bullet point line"
		*/
		var parserEmulationProfile = createObject("java", "com.vladsch.flexmark.parser.ParserEmulationProfile", javaLib);
		var options = parserEmulationProfile.COMMONMARK_0_28.getProfileOptions();

		var renderer = CreateObject( "java", "com.vladsch.flexmark.html.HtmlRenderer", javaLib)
				.builder(options).build();
		_setHtmlRenderer( renderer );
	}

	private void function _setupNoticeBoxRenderer() {
		_setNoticeBoxRenderer( new api.rendering.NoticeBoxRenderer() );
	}

	private any function _getMarkdownProcessor() output=false {
		return _markdownProcessor;
	}
	private void function _setMarkdownProcessor( required any markdownProcessor ) output=false {
		_markdownProcessor = arguments.markdownProcessor;
	}

	private any function _getHtmlRenderer() output=false {
		return _htmlRenderer;
	}
	private void function _setHtmlRenderer( required any htmlRenderer ) output=false {
		_htmlRenderer = arguments.htmlRenderer;
	}

	private any function _getNoticeBoxRenderer() {
		return _noticeBoxRenderer;
	}
	private void function _setNoticeBoxRenderer( required any noticeBoxRenderer ) {
		_noticeBoxRenderer = arguments.noticeBoxRenderer;
	}


	private array function _getJavaLibs(){
		if (not structKeyExists(variables, "cachedJavaLibs"))
			variables.cachedJavaLibs = directoryList("../lib", false, 'array', "*.jar");
		return variables.cachedJavaLibs;
	}
}