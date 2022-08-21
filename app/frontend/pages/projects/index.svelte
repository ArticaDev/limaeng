<script>
    export let projects;
</script>

{#each projects as project}
    <li class="text-orange-500">{project.name}</li>
{/each}
