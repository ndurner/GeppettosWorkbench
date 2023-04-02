var observer = new MutationObserver(function(mutations) {
    for (const mutation of mutations) {
        for (const addedElem of mutation.addedNodes) {
            const banners = addedElem.querySelectorAll('.chat-gpt-banner, .pg-welcome');
            for (const banner of banners) {
                banner.remove();
            }
        }
    }
});

observer.observe(document, {attributes: false, childList: true, characterData: false, subtree:true});
