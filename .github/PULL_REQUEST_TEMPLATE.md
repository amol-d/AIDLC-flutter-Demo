## What & why

<!-- Summary of the change and the requirement (issue/ticket) it satisfies. -->

Closes #

## Checklist

- [ ] `dart run melos run format` / `analyze` / `test:unit` all green locally
- [ ] Layer rules respected (domain does not import data; blocs call use cases; navigation via AppNavigator)
- [ ] New DTOs have wire-shape tests; new use cases have forwarding tests; new blocs have success+failure tests
- [ ] User-facing strings added to BOTH `intl_en.arb` and `intl_hi.arb`
- [ ] New public symbols exported from the package barrel
- [ ] No secrets, generated files, or hand-edits to `*.g.dart`/`*.freezed.dart`/`*.gr.dart`/`*.config.dart`

## Test evidence

<!-- Command output, screenshots (run app1 on chrome), or recordings. -->
