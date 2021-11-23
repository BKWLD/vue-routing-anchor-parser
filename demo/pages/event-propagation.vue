<!-- Testing that events can propagate -->

<template lang='pug'>

.event-propagation.wysiwyg
	h1 Event Propagation

	h2 Renders &lt;nuxt-link&gt;
	p: smart-link(
		to='/'
		@click='onClick("nuxt-link")') Click me

	h2 Renders &lt;a&gt;
	p: smart-link(
		to='http://www.bukwild.com'
		@click='onClick("anchor")') Click me

	h2 Renders &lt;span&gt;
	p: smart-link(
		@click='onClick("span")') Click me

</template>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<script lang='coffee'>
export default

	methods:

		# Test clicks
		onClick: (source) -> alert "#{source} clicked"

</script>

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>



</style>
