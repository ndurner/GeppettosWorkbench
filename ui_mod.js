var observer = new MutationObserver(function(mutations) {
    for (const mutation of mutations) {
        for (const addedElem of mutation.addedNodes) {

            // declutter
            const banners = addedElem.querySelectorAll('.chat-gpt-banner, .pg-welcome');
            for (const banner of banners) {
                banner.remove();
            }

            // slider presets
            const sliders = addedElem.querySelectorAll('.slider');
            for (const slider of sliders) {
                var label = slider.querySelector('span');
                var input = slider.querySelector('input');

                if (label !== null && input !== null) {
                    var txt = label.innerText;
                    var confirm = false;

                    if (txt === 'Temperature') {
                        input.value = '0';
                        confirm = true;
                    }
                    else if (txt === 'Maximum length') {
                        input.value = '2048';
                        confirm = true;
                    }

                    if (confirm) {
                        const inputEvent = new Event('input', { bubbles: true, cancelable: true });
                        input.dispatchEvent(inputEvent);
                    }
                }
            }

            // instructions
            const instr = addedElem.querySelector('.chat-pg-instructions');
            if (instr !== null) {
                var inp = instr.querySelector('textarea');
                if (inp !== null) {
                    inp.textContent = 'You are a helpful assistant, giving factual and faithful answers. Say idk if unsure';

                    const inputEvent = new Event('input', { bubbles: true, cancelable: true });
                    inp.dispatchEvent(inputEvent);
                }
            }
        }
    }
});

observer.observe(document, {attributes: false, childList: true, characterData: false, subtree:true});
