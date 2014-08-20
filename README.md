# jquery-ticker

Rewrite of [jQuery.ticker](https://github.com/ranadesign/jQuery.ticker)

---
## Required
### jQuery (Developed on 2.1.1)
http://jquery.com/

---
## Demos
http://seckie.github.io/jquery-ticker/demo

---
## Usage

### Step01
Load jquery.js and this plugin in "head" element

```
<script src="jquery.js"></script>
<script src="jquery.ticker.js"></script>
```

### Step02
Set style ``display:inline-block: float:left;`` to elements of content.

```
<style>
.ticker-item {
  display: inline-block;
  float: left;
}
</style>

<div class="ticker">
<div class="ticker-item"> ... </div>
<div class="ticker-item"> ... </div>
<div class="ticker-item"> ... </div>
</div>
```


### Step03
Get the content's parent element via jQuery selector, and fire the plugin with some options.

```
<script>
$(function() {
  $('.ticker').ticker(
    content: '.ticker-item'
  );
});
</script>
```

#### Options

<table border="1">
<colgroup span="1" class="colh">
<colgroup span="1" class="colh">
<colgroup span="1" class="cold">
<thead>
<tr>
<th>option name</th>
<th>default value</th>
<th>data type</th>
<th>description</th>
</tr>
</thead>
<tbody>
<tr>
<td>content</td>
<td>".ticker-item"</td>
<td>String<br>(Selector String)</td>
<td>Content elements selector (<b>required</b>)</td>
</tr>
<tr>
<td>duration</td>
<td>500</td>
<td>Number</td>
<td>Duration of animation. If you set shorter, animation gets faster.</td>
</tr>
<tr>
<td>wrapperClassName</td>
<td>"ticker-wrapper"</td>
<td>String</td>
<td>Wrapper DIV that has this className will generate by the plugin.</td>
</tr>
<tr>
<td>innerClassName</td>
<td>"ticker-inner"</td>
<td>String</td>
<td>Inner DIV that has this className will generate by the plugin.</td>
</tr>
<tr>
<td>hoverStop</td>
<td>true</td>
<td>Boolean</td>
<td>Whether stop animation when mouseover</td>
</tr>
</tbody>
</table>

---
## License
<a href="http://www.opensource.org/licenses/mit-license.html">MIT License</a>
