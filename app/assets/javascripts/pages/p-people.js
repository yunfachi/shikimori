pageLoad('people_show', async () => {
  $('.b-entry-info').checkHeight({ max_height: 101, without_shade: true });

  // комментировать
  $('.b-subposter-actions .new_comment').on('click', () => {
    const $editor = $('.b-form.new_comment textarea');
    $.scrollTo($editor, () => $editor.focus());
  });

  const { FavoriteStar } =
    await import(/* webpackChunkName: "db_entries_show" */ 'views/animes/favorite_star');

  Object.keys(gon.is_favoured).forEach(role => {
    if (gon.person_role[role] || gon.is_favoured[role]) {
      const $button = $(`.b-subposter-actions .fav-add[data-kind='${role}']`);

      $button.show();
      new FavoriteStar($button, gon.is_favoured[role]);
    }
  });
});
