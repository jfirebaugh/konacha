describe("spec file isolation (A)", function () {
  it("isolates globals in one spec file from those of other spec files", function () {
    window.a_spec = true;
    expect(window.b_spec).to.be.undefined;
  });
});
