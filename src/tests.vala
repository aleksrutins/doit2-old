void tests() {
    Assert.suite("Test suite", (ctx) => {
        ctx.it("Should work", () => {
            ctx.assert(false, "True shuld be true");
        });
    }).run();
}
