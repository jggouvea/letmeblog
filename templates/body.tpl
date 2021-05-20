<div id="main"><h1 class="header">$title$</h1>
	<div id="main-content">
		$if(published)$
		  <div class="published">Publicado em: $published$</div>
		$endif$

		$if(abstract)$
		<div class="intro">$abstract$</div>
		$endif$
				
		$if(toc)$
		<div id="TOC" role="doc-toc">
		<b id="toc-title">Sumário</b>
		$table-of-contents$
		</div>
		$endif$
		
			  $body$

		$if(published)$
		  <div id="context">
			<a class="fas fa-arrow-left" href="$aftr$"></a>
			<a id="newer" href="$aftr$">seguinte</a>
			<span id="expander fas"></span>
			<a id="older" href="$befo$">anterior</a>
			<a class="fas fa-arrow-right" href="$befo$"></a>
		  </div>
		$endif$
		
		$if(published)$
			<div id="categories"><b>Arquivado em: </b>
			  $for(categories)$
			  <a href="/categorias/$categories$/index.html">$categories$</a>
			  $endfor$
			</div>
		  
			<div id="tags"><b>Assuntos: </b>
			  $for(tags)$
			  <a href="/assuntos/$tags$/index.html">$tags$</a>
			  $endfor$
			</div>
		$endif$

	</div>
</div>
