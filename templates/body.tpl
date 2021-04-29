<div id="main"><h1 class="header">$title$</h1>
	<div id="main-content">
		$if(published)$
		  <div class="published">Publicado em: $published$</div>
		$endif$
		
		$if(toc)$
		<div id="$idprefix$TOC" role="doc-toc">
		$if(toc-title)$
		<b id="$idprefix$toc-title">$toc-title$</b>
		$endif$
		$table-of-contents$
		</div>
		$endif$
		
			  $body$
		
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
