# lab

## Code Examples

<input type="radio" name="language" id="tab1" checked>
<label for="tab1">Python</label>
<input type="radio" name="language" id="tab2">
<label for="tab2">JavaScript</label>

<div id="content1">
    ```python
    def hello_world():
        print("Hello, Python!")
    ```
</div>

<div id="content2" style="display:none;">
    ```javascript
    function helloWorld() {
        console.log("Hello, JavaScript!");
    }
    ```
</div>

<script>
document.querySelectorAll('input[name="language"]').forEach(radio => {
  radio.addEventListener('change', (e) => {
    document.getElementById('content1').style.display = e.target.id === 'tab1' ? 'block' : 'none';
    document.getElementById('content2').style.display = e.target.id === 'tab2' ? 'block' : 'none';
  });
});
</script>
